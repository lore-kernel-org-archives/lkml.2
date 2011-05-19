Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab1ESD7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:59:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53478 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932268Ab1ESD67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:58:59 -0400
X-Sasl-enc: rbVOkWK+Wbv2d9m2A+9Mgu5M7WEWQact0tfsou+TIw0U 1305777538
Date: Wed, 18 May 2011 20:58:03 -0700
From: Greg KH <greg@kroah.com>
To: anish singh <anish198519851985@gmail.com>
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: patch for Checkpatch.pl
Message-ID: <20110519035803.GA9867@kroah.com>
References: <BANLkTikYRvHb0ffdpdzpiTh7S+Ayxw1wew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikYRvHb0ffdpdzpiTh7S+Ayxw1wew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 08:39:57AM +0530, anish singh wrote:
> I am thinking of submitting a patch for checkpatch.pl.
>  
> Ideally it should give a warning when there is no space between
> patch submitter name and the email id as below:
> Signed-off-by: anish kumar<anish@gmail.com>
>  
> It should be as below:
> Signed-off-by: anish kumar <anish@gmail.com>
>  
> Please let me know if it is fine.I will send it right away as i have
> it ready.

As you are the only one I have ever seen do this before, I doubt it's
really needed for the checkpatch script, right?

