Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab0F1Kwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 06:52:33 -0400
Received: from tpa-qmail.dyxnet.com ([152.104.96.30]:35400 "HELO
	tpa-qmailr1.dyxnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751950Ab0F1Kwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 06:52:31 -0400
X-DYX-POP3-Checked-Auth: 192.168.131.61:kernel@takeo.idv.tw
Message-ID: <F2CA952B7B5A41259C5F950CA3454C3A@TAKEOW7NB1>
From: "Takeo Tung" <kernel@takeo.idv.tw>
To: "Christoph Hellwig" <hch@lst.de>
Cc: "Michal Marek" <mmarek@suse.cz>, <linux-kernel@vger.kernel.org>,
       <viro@zeniv.linux.org.uk>, <sfr@canb.auug.org.au>,
       "Takeo Tung" <kernel@takeo.idv.tw>
References: <10E8B8D94205471F942B06D2A007832D@TAKEOW7NB1> <4C129778.7040409@suse.cz> <F8C0125B8F424A279E9679EAC24AC983@TAKEOW7NB1> <20100612094937.GA12455@lst.de>
In-Reply-To: <20100612094937.GA12455@lst.de>
Subject: block: unify flags for struct bio and struct request will kernel panic
Date: Mon, 28 Jun 2010 18:52:25 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8089.726
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8089.726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Christoph,

As subject, I revert the patch, seems boot is normal, but apply the patch,
kernel will panic on scsi_setup_fs_cmnd, could you can check this? bcoz I 
check long time,
no found why kernel will panic.

http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fnext%2Flinux-next.git;a=commitdiff_plain;h=74450be123b6f3cb480c358a056be398cce6aa6e

Thanks,
Takeo Tung
 

