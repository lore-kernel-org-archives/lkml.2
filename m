Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2KUKOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:14:04 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:39766 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2KUKOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:14:01 -0500
Message-ID: <50ACA963.4080901@gmail.com>
Date: Wed, 21 Nov 2012 11:13:55 +0100
From: MAACHE Mehdi <mehdi.maache@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.10) Gecko/20121029 Thunderbird/10.0.10
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: Re: [PATCH] Staging: rtl8187se: fixed some checkpatch warnings and
 errors in r8180_wx.c
References: <1353418002-8254-1-git-send-email-mehdi.maache@gmail.com> <20121120142504.GC11248@mwanda>
In-Reply-To: <20121120142504.GC11248@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 20/11/2012 15:25, Dan Carpenter a écrit :

> On Tue, Nov 20, 2012 at 02:26:42PM +0100, MAACHE Mehdi wrote:
>> This is a patch to the r8180_wx.c file that fixes up some warnings and errors found by the checkpatch.pl tool
>> - WARNING: line over 80 characters
>> - ERROR: "(foo*)" should be "(foo *)"
>> - ERROR: "foo* bar" should be "foo *bar"
>> - ERROR: trailing whitespace
>> - ERROR: that open brace { should be on the previous line
>>
> 
> This needs to be broken into 4-5 separate patches and sent as
> series.  One patch per warning type.
> 
>> -	if (erq->flags & IW_ENCODE_DISABLED)
>> -
>> -	if (erq->length > 0) {
>> -		u32* tkey = (u32*) key;
>> +	if ((erq->flags & IW_ENCODE_DISABLED) && erq->length > 0) {
>> +		u32 *tkey = (u32 *) key;
> 
> Interesting...  You have preserved the meaning of the original code,
> but actually the original code is buggy.  Just delete the
> "if (erq->flags & IW_ENCODE_DISABLED)" check.  This bug was
> introduced in de171bd6ff "Staging: rtl8187se: r8180_wx: fixed a lot
> of checkptahc.pl issues".
> 
> Send that as a separate patch and mark it as a bugfix.
> 
> regards,
> dan carpenter
> 


Ok, I will do this. Thanks for the advice.

regards,

maache mehdi
