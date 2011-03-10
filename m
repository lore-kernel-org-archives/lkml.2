Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1CJVOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:14:17 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:50074 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab1CJVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:14:16 -0500
Date: Thu, 10 Mar 2011 22:14:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mark Hounschell <markh@compro.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel git bisect question
Message-ID: <20110310211414.GA31719@merkur.ravnborg.org>
References: <4D793414.4090206@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D793414.4090206@compro.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 03:27:00PM -0500, Mark Hounschell wrote:
> Between git bisect [good | bad ]s should I always "make clean" or can I
> count on the build system to take care of everything properly?

You can count on the build system to take care.
It is very rare that the build system does not handle this.

Lately we fixed a bug where we did not properly handled when a file
was renamed from *.S to *.c. But you will most likely not hit this.

	Sam
