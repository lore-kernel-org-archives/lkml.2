Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab0ITTAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:00:00 -0400
Received: from smtp.infotech.no ([82.134.31.41]:36935 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab0ITS76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:59:58 -0400
Message-ID: <4C97AF27.3080101@interlog.com>
Date: Mon, 20 Sep 2010 14:59:51 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH 2/3] tcm: Add VARIABLE_LENGTH_CMD support w/	XDWRITE_READ_32
 emulation
References: <1284701695-18367-1-git-send-email-nab@linux-iscsi.org>	 <4C95FF76.4040005@panasas.com> <1284973101.13344.444.camel@haakon2.linux-iscsi.org> <4C97341E.5090501@panasas.com>
In-Reply-To: <4C97341E.5090501@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-09-20 06:14 AM, Boaz Harrosh wrote:
> On 09/20/2010 10:58 AM, Nicholas A. Bellinger wrote:

[snip]

>> Btw, I have not been able to find a definitive list of the service
>> actions of VARIABLE_LENGTH_CMD for TYPE_DISK in the SBC3 spec that need
>> to be added to scsi.h.  Have you come across one in your own readings
>> for these..?
>>
>
> Sorry, no, I'm only an OSD guy. Perhaps Martin or Matthew

spc4r26.pdf Annex D.3.5
sbc3r24.pdf Annex A.1

Doug Gilbert
