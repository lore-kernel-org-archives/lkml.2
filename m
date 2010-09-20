Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0ITJG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:06:28 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:48912 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753480Ab0ITJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:06:26 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: JB.PWykVM1n46yNMR3pdqGfbvzqNwU0j0Een1g1Q_jCsN5m
 f_uqFm.mfxmL55eMN0R4ucnAdwQuxp9BRnLE7HyA3WEz7vcnXg1.wwkU9jFg
 Rxs4ZCZjZqNUrg4eobJ55CgOkDLMsvXQB8n0q9Ueg5fVPjG2uzUS6fIsk04.
 vwhMADYdd0LbQ1eBzTnkG6BhQBuvmmfPFeHYQajPLcbl3ws_g5smE3YOsGaA
 qEY63itWI6faHdnNxaJqVhFbg4IAO4wOBANDPjhn1iYoOQGj.UVFDLl6X8dQ
 MrIUBdbGib6sN.O6f0b8MtFjRFtJPyuNjIXXxzDnLz_JMkW_rT96KMdHo
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH v2 1/2] tcm: Add support for BIDI-COMMANDS and
	XDWRITE_READ_10 emulation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Joe Eykholt <jeykholt@cisco.com>
In-Reply-To: <4C961044.3010500@panasas.com>
References: <1284590512-6233-1-git-send-email-nab@linux-iscsi.org>
	 <4C961044.3010500@panasas.com>
Content-Type: text/plain
Date: Mon, 20 Sep 2010 02:02:15 -0700
Message-Id: <1284973335.13344.449.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-19 at 15:29 +0200, Boaz Harrosh wrote:
> On 09/16/2010 12:41 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> 
> Hi dear Nicholas
> 
> I still have a few reservations regarding the use of the:
> +	int			t_tasks_bidi:1;
> 
> at struct se_transport_task at minimum I'd use the t_tasks_se_bidi_num
> as a look ahead. But I hate that as well. I suspect none of this is
> needed. But
> 

Yes, unfortuately AFAICT this is required by the fabric module during
the initial I/O setup phase in order signal TCM Core before the
T_TASK(cmd)->t_mem_bidi_list is setup w/o depending upon
DMA_BIDIRECTIONAL or something else like it..

> At http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git I still get
> an old head without these or the CDB32 stuff.
> 
> Where can I find a git web. With latest bits? I'd like to have a
> closer look.
> 

My 'upstream' v4.0 branch that all of the changes have been going into
is here..

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=shortlog;h=refs/heads/lio-4.0

> (You know that I have a vested interest in all this I need it to be solid)
> 

Many thanks Boaz!

--nab


