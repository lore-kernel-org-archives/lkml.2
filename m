Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab0IZSfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:35:48 -0400
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:35276 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757418Ab0IZSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:35:47 -0400
Subject: Re: [PATCH 10/10] Fs: ext4: namei: fixed file of checkpatch/pl
 warnings and errors
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Tracey Dent <tdent48227@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100926182338.GM19690@thunk.org>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	 <1285439521-2557-10-git-send-email-tdent48227@gmail.com>
	 <m3pqw16mfh.fsf@intrepid.localdomain>  <20100926182338.GM19690@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Sep 2010 14:35:41 -0400
Message-ID: <1285526141.3047.0.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-26 at 14:23 -0400, Ted Ts'o wrote:
> On Sun, Sep 26, 2010 at 08:36:34AM +0200, Krzysztof Halasa wrote:
> > 
> > BTW I wouldn't trust checkpatch so blindly. Also keep in mind checkpatch
> > is only a tool and that maintainers have full authority to ignore the
> > problems (or "problems") it spews.
> 
> I'm beginning to think we need to have an entry in the kernel newbie's
> FAQ warning people that the output of various scripts such as
> checkpatch and get_maintainer are not authoratative, and are
> hueristics intended to be supplemented by human intelligence.

It would actually be quite useful to add a warning in kernelnewbies
about this, some people tend to get too carried away :)

Davidlohr
> 
> 	   	       	  	       	  	- TEd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


