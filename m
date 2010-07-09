Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0GIBvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:51:10 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43770 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0GIBvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=GN9I0po1AHLklb82/6/MbuxYxdzsIupVWh3z3Rt8livVXu07GHD1cKrXnPgkFa/ZJb
         T3qld69o6glaLHPptaRMz9snynWovY5sQ0DuVou5LSY1oX5DUGgFRfuRozmm2v3lscC/
         /ZAAxFmom2ZaNORnL+8GtdnzKluIwlxOd26j4=
Message-ID: <4C3680D1.5070601@lwfinger.net>
Date: Thu, 08 Jul 2010 20:52:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Warning message when using sparse
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On recent kernels, sparse reports the following message for every source 
file that is processed. The warning does not seem to affect the results. 
I'm not sure when the problem started, but I think it was with 2.6.35-rc1.


   CHECK   drivers/staging/rtl8712/rtl871x_rf.c
/home/finger/linux-2.6/arch/x86/include/asm/cpufeature.h:297:21: error: 
Expected ( after asm
/home/finger/linux-2.6/arch/x86/include/asm/cpufeature.h:297:21: error: 
got goto


Larry
