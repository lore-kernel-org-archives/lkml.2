Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab1ARFEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 00:04:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab1ARFEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 00:04:35 -0500
Message-ID: <4D351F25.7000708@suse.de>
Date: Tue, 18 Jan 2011 10:33:33 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Francesco Alfano <edacedpa@yahoo.it>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: Lose shared network resource
References: <395199.61799.qm@web29510.mail.ird.yahoo.com>
In-Reply-To: <395199.61799.qm@web29510.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(good to Cc linux-cifs@vger.kernel.org though it might not have anything
to do with cifs in this case)

On 01/13/2011 09:06 PM, Francesco Alfano wrote:
> Hello, 
> I have a problem with the (exported) sharing of network resources. 
> Initially i've used a sever with RedHat 7.3 kernel 2.4 now i've  installed 
> Scientific Linux 5.5 with kernel 2.6.18-194.32.1.el5PAE with  Samba version 
> 3.0.33-3.29.el5_5.1. 
> 
> The problem is that I lose the network connection periodically, about 10  
> minutes! 
> 

Are you using dhcp? If yes, it looks like a problem due to IPaddress not
being persistent (possibly a bug in dhcpcd).

Are you able to reproduce this problem if you use static IP?  Also, see
if the problem is persisting if you use dhclient instead of dhcpcd.


-- 
Suresh Jayaraman
