Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab1CBMti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 07:49:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39921 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab1CBMth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 07:49:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L95/oCoxALAU1CpE1d5pTDM2ZK1AllSfoidCgchBtJXkeh/+oVnk4w9jB1LnKMndOE
         mz3c/F8EYviwUAxeuNHyRqdlkR+K7YNCueqQKOL8+5aEb5fYOxQiyodGpiQARZMXU0iV
         VhQzRQ/A3Hqy5yDlzOmpN8dx6HTkiZyuD7JJE=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=wkhYjy9D-GpgjLvg6zK88uZ8FkBb5fM6Y1-xd@mail.gmail.com>
References: <201011181650.00152.roucaries.bastien@gmail.com>
	<20101223034229.GF1739@nowhere>
	<201101300108.32383.roucaries.bastien@gmail.com>
	<201102161722.24963.roucaries.bastien@gmail.com>
	<20110216165456.GA3090@nowhere>
	<AANLkTi=wkhYjy9D-GpgjLvg6zK88uZ8FkBb5fM6Y1-xd@mail.gmail.com>
Date: Wed, 2 Mar 2011 13:49:36 +0100
Message-ID: <AANLkTin6C3ppB_+9+vYRsg5hTFJQHU7RBAyJ6JWkU8ma@mail.gmail.com>
Subject: Re: Regression with dataloss: Reiserfs deadlock in 2.6.36 and 2.6.37,
 know working 2.6.33
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linus@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:15 AM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
> On Wed, Feb 16, 2011 at 5:55 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> On Wed, Feb 16, 2011 at 05:22:21PM +0100, Bastien ROUCARIES wrote:
>>> Le dimanche 30 janvier 2011 01:08:29, Bastien ROUCARIES a écrit :
>>> > Le jeudi 23 décembre 2010 04:42:33, Frederic Weisbecker a écrit :
>>> > Hi,
>>> >
>>> Dear Andrew,
>>>
>>> Since three month I suffer fo regular dataloss in reiserfs kernel. I have posted all the detail  on #29162 under bugzilla.
>>>
>>> This bug freeze my notebook every hour between 6 hours. using git pull and compiling kernel seems to exercice this bugs.
>>>
>>> Frederic is really busy by academic millestones and I really thank him for his previous help, do you know somebody willing to
>>> help?

Any news of this bug ?

Can I help ?

Bastien
