Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab0IYR1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 13:27:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43283 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab0IYR1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 13:27:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=G9MkHRAXXxoTNoraDpr/rsmTt88zqv7fli/Mm97451i9+LmrEgBe0G16BC8bUZeH49
         ibjb1mlJRyYkSu+vsbzmunRHUb6q5xZo05ocZxn3YLKLZGkrmwuXjIsrlumgdT9eN+Wt
         KzJn/+C7XM8HULTWlmHRVyd27tEMXs06sb1f4=
MIME-Version: 1.0
In-Reply-To: <20100925150415.GA4124@suse.de>
References: <1285422505-7128-1-git-send-email-rahul.ruikar@gmail.com>
 <AANLkTik-1noL87D7dnq8AzV9i9BfxYoa-KboAB15r=oT@mail.gmail.com> <20100925150415.GA4124@suse.de>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Sat, 25 Sep 2010 22:57:08 +0530
Message-ID: <AANLkTinnRFCRpfZwTTsCNtJa8s_HFhv=toORXjT_5p1e@mail.gmail.com>
Subject: Re: [PATCH] misc: phantom: Added missing warning messages in phantom_probe
To: Greg KH <gregkh@suse.de>
Cc: jirislaby@gmail.com, ak@linux.intel.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Actually before sending patch I run get_maintainer.pl script against
this patch and  it gave me all following names..
that was reason i added you in maill.

[rahul@Ganesha linux-2.6]$ ./scripts/get_maintainer.pl
0001-misc-phantom-Added-missing-warning-messages-in-phant.patch
Jiri Slaby <jirislaby@gmail.com>
Andi Kleen <ak@linux.intel.com>
Alexey Dobriyan <adobriyan@gmail.com>
Greg Kroah-Hartman <gregkh@suse.de>
Andrew Morton <akpm@linux-foundation.org>
Rahul Ruikar <rahul.ruikar@gmail.com>
linux-kernel@vger.kernel.org


- Rahul Ruikar





On 25 September 2010 20:34, Greg KH <gregkh@suse.de> wrote:
> On Sat, Sep 25, 2010 at 07:45:10PM +0530, Rahul Ruikar wrote:
>> missed greg in earlier mail.
>
> Ok, but why?  Is drivers/misc/phantom.c my code?
>
> confused,
>
> greg k-h
>
