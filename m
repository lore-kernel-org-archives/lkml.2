Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab0FBLkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:40:51 -0400
Received: from crca.org.au ([74.207.252.120]:44227 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab0FBLkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:40:49 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C064338.3070302@crca.org.au>
Date: Wed, 02 Jun 2010 21:40:40 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: rjw@sisk.pl, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 1/9] PM / Hibernate: swap, switch to hibernate_io_handle
References: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1275468768-28229-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri et al.

On 02/06/10 18:52, Jiri Slaby wrote:
> Hi,
>
> I addressed the comments I got on the previous RFC. I left the handles
> in place, the functions in hibernate_io_ops now works on them. Further
> I got rid of the memory barriers and minimized global variables as much
> as possible. Comments welcome.

Hmm. I've been working on a set of patches too!

How about if I post them in shortly. We can then look at where there's 
overlap and what to take from each.

Nigel
