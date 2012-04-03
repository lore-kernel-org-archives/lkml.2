Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab2DCIhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:37:34 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38608 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2DCIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:37:30 -0400
Message-ID: <4F7AB6BF.5050605@ahsoftware.de>
Date: Tue, 03 Apr 2012 10:37:19 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Genes MailLists <lists@sapience.com>
CC: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bluetooth: fix deadlock on device reset and power down
References: <4F77055A.2070502@ahsoftware.de> <20120402065525.GA29687@aemeltch-MOBL1> <4F79B74E.6080207@sapience.com>
In-Reply-To: <4F79B74E.6080207@sapience.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Genes MailLists, ;)

Am 02.04.2012 16:27, schrieb Genes MailLists:
>
>
>      Hi - is this related issue? (crash at shutdown/sleep):
>
> https://bugzilla.kernel.org/show_bug.cgi?id=42975

Looks likely.

Do you have tried if the patch from Andre Guedes (commit 
e72acc13c770a82b4ce4a07e9716f29320eae0f8 in Linus tree) helps?

Regards,

Alexander
