Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1BJK7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 05:59:07 -0500
Received: from lo.gmane.org ([80.91.229.12]:43129 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab1BJK7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 05:59:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Eggink <monoped@sudrala.de>
Subject: Re: "HDIO_GET_IDENTITY failed" messages in 2.6.38-rc4
Date: Thu, 10 Feb 2011 11:58:52 +0100
Message-ID: <ij0gdc$5cn$1@dough.gmane.org>
References: <iiui4n$pcb$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: d040140.adsl.hansenet.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
In-Reply-To: <iiui4n$pcb$1@dough.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.02.2011 18:16, schrieb Bernd Eggink:
> I have a system with a SCSI CD burner (Plextor). Worked fine under
> 2.6.37, but 2.6.38-rc4, when booting, floods the display with messages
> "HDIO_GET_IDENTITY failed for /dev/sr0".

I noticed that the messages start when

	udevadm trigger --type=devices --action=add

is executed. There are about 50 udev daemons in the process list.

Bernd

