Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab0KPHbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 02:31:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46315 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0KPHbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 02:31:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MbmfcBQGfNC84MFB9n2mO1a33W4la+lLESnKfic+rAwXu+uJIv6+QhPbpyegfHyhkc
         /QAkZAPY8J21SaEpQa1Z0wd7mrrwdFyZTYH45lqNOVrS5O1h4+3OAF+yu+IE67iSX5Cv
         +e6lzoM3DFUTwDgF6gvNzEda8yg0EzE1GnLWM=
Message-ID: <4CE23355.6090205@garzik.org>
Date: Tue, 16 Nov 2010 02:31:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] SCSI host lock push-down
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com> <20101113051635.GA11613@havoc.gtf.org> <20101116071029.GA13540@havoc.gtf.org>
In-Reply-To: <20101116071029.GA13540@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 02:10 AM, Jeff Garzik wrote:
> and remove one parameter from queuecommand,
> 	void (*done)(struct scsi_cmnd *)

add appropriate credit to James (and willy?) for this bit...

