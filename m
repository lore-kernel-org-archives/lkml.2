Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0CYGLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 02:11:45 -0400
Received: from crca.org.au ([74.207.252.120]:46989 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab0CYGLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 02:11:44 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BAAFED5.6070501@crca.org.au>
Date: Thu, 25 Mar 2010 17:12:37 +1100
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100301 Shredder/3.0.4pre
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-pm@lists.linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
       jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] what the patches do Re: [RFC 10/15] PM / Hibernate:
 user, implement user_ops reader
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>	<1269361063-3341-10-git-send-email-jslaby@suse.cz>	<20100325053003.GB12935@elf.ucw.cz> <4BAAF7DA.30506@crca.org.au>
In-Reply-To: <4BAAF7DA.30506@crca.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On 25/03/10 16:42, Nigel Cunningham wrote:
> On 25/03/10 16:30, Pavel Machek wrote:
> [...]
>
>> I have some problems with sws_module_ops interface (handcoded locking
>> is too ugly to live), but it is better than I expected. But there may
>> be better solution available, one that does not need two interfaces to
>> maintain (we can't really get rid of userland interface). What about
>> this?
>
> Just picking up on that bracketed part: Can we flag the userland
> interface (and uswsusp) as being planned for eventual removal now... or
> at least agree to work toward that?
>
> I'm asking because if we're going to make a go of getting the in-kernel
> code in much better shape, and we have Rafael, Jiri and I - and you? -
> all pulling in the same direction to improve it, there's going to come a

I realised after sending this that the " - and you? - " was ambiguous. I 
wasn't meaning to suggest that you might pull in a different direction, 
but rather uncertainty as to whether you might help with the effort - 
it's been a while (AFAIR) since you've done any hibernaton patches.

Humble apologies for the ambiguity!

Nigel
