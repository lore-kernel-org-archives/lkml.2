Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab1ADLIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 06:08:43 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:58070 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1ADLIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 06:08:42 -0500
Date: Tue, 4 Jan 2011 12:08:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
        LKML <linux-kernel@vger.kernel.org>, kernel-team@lists.ubuntu.com
Subject: Re: Kernel build
Message-ID: <20110104110841.GA12647@merkur.ravnborg.org>
References: <AANLkTins3HdRJ-Y7bCuXFjOhjx+-nxDHSqUxBPuuxFxg@mail.gmail.com> <alpine.DEB.2.00.1101040329450.7740@localhost6.localdomain6> <AANLkTinffZs-FD+PuBdavmiNpR4AK3T9eQ_EQaEqLtWB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinffZs-FD+PuBdavmiNpR4AK3T9eQ_EQaEqLtWB@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 12:09:21PM +0200, Anca Emanuel wrote:
> On Tue, Jan 4, 2011 at 10:30 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> > On Tue, 4 Jan 2011, Anca Emanuel wrote:
> >
> >> Question: Why I need to rebuild all the modules, if they are already builded.
> >> https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
> >> If I make an one line change, I need to wait one hour to make an new
> >> kernel on an intel core duo at 2GHz sistem ?

make V=2 will tell you what file/config entry caused the rebuild to happen.

> 
> This is not an kernelnewbies qestion.
> This in an Google project question.
> Search for it.
I did. No luck. Any pointer?

	Sam
