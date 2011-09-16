Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1IPSt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:49:59 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51344 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754757Ab1IPSt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:49:58 -0400
X-Sasl-enc: 4YFQJUwo1hRnXNGl9A4JjjLWhXkzZ0OA/oq+EtVZqX4d 1316198997
Date: Fri, 16 Sep 2011 20:47:25 +0200
From: Greg KH <greg@kroah.com>
To: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 00/44] Staging: cx25821: Fix style issues
Message-ID: <20110916184725.GA31993@kroah.com>
References: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316153717-7272-1-git-send-email-leonidsbox@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 02:14:33PM +0800, Leonid V. Fedorenchik wrote:
> This patch series fixes up style issues in cx25821-video.{c,h} files in
> drivers/staging/cx25821
> 
> What the heck with patches 5-39? ... Well, in cx25821-video.c file there
> are lots of lines starting with 7 spaces where clearly this intented to
> be a tab; that is reported by checkpatch.pl script. And even more lines
> that start with one or more tabs and 7 spaces; this is intented to be 2
> or more tabs instead and this is not reported by checkpatch.pl script
> (obviously). So, first, I fix up all that kind of wrong indents and
> resulting patch was too big and unreviewable. (around 2K lines) So,
> since I haven't thought of better way to make the patch reviewable, I
> decided to split that huge patch into small reviewable patches. The
> result is 35 patches. %-) If you can think of a better way to deal with
> this, let me know.

Looks good, all now applied, thanks.

greg k-h
