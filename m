Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0IOWpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:45:09 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.205]:29807 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754631Ab0IOWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:45:07 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: ks7sQaUVM1lbezeG3Zr8IbnPQwJ1KmigYWWoBe8SP3s6LLk
 zdT9eU.BRCJnbRVnNZ.W4jPVBVe7mgaC.uEiy0MNa3RoQEjQAiVWovDR3cVv
 SPnaJbt58tp3GHTIZZGYLRYIvsmyme7I.n0ZvQb_ZwgA0njyie.t_hS3GKhf
 7To6.m2Fn5LJZ5HKzd0pH5Y9scUQmj1c0nyEYzAmL5nM4khKqewLZG3_cvYl
 wyCk8x.wJNQdp0igEjNsSH9ojV7ytAmO1M9p85uCvK7knVJzeOpsr1Cdijfv
 Ja67KLVnRMbzLpvs6BF_j7sM1XidEw1Yg4.H76B9HIVpw3zlPThx4XjmuHcl
 e1b3DAz80B.uy5egvvg--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH v2 1/2] tcm: Add support for BIDI operation and
	XDWRITE_READ_10 emulation
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Joe Eykholt <jeykholt@cisco.com>
In-Reply-To: <1284590521-6254-1-git-send-email-nab@linux-iscsi.org>
References: <1284590521-6254-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain
Date: Wed, 15 Sep 2010 15:40:59 -0700
Message-Id: <1284590459.13344.42.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 15:42 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This v2 patch series adds BIDI-COMMANDS support to TCM Core.  This
> includes the following for struct se_cmd to handle BIDI READ payloads using a new
> struct se_transport_task->t_mem_bidi_list and struct se_transport_task->t_tasks_se_bidi_num.
> The model employed is to keep the WRITE payload at struct se_transport_task->t_mem_list,
> and add a new BIDI READ payload memory list at struct se_transport_task->t_mem_bidi_list.
> 

Sorry, this patch is a PRE rebased DUPE..  Please ignore it.

Best,

--nab

