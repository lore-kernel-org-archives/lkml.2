Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1LYWZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 17:25:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40239 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1LYWZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 17:25:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavan Savoy <pavan_savoy@sify.com>
Subject: Re: runtime PM + legacy PM
Date: Sun, 25 Dec 2011 23:28:19 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <CABUK1ahQ2yYzaezGc=vDYPrL4ejQgC+9oNtvLeFNJRFf9wAGLw@mail.gmail.com> <201112222255.22288.rjw@sisk.pl> <CABUK1ajfBa6cMmse6Kg8vWOabnaepUqoLAzdnn5X4rAQGNqMpw@mail.gmail.com>
In-Reply-To: <CABUK1ajfBa6cMmse6Kg8vWOabnaepUqoLAzdnn5X4rAQGNqMpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112252328.19649.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 25, 2011, Pavan Savoy wrote:
> On Thu, Dec 22, 2011 at 3:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, December 22, 2011, you wrote:
> >> Is there a need for the legacy PM to be enabled when device/drivers
> >> run-time PM is supported ?
> >
> > What do you mean by "legacy PM"?
> 
> I meant suspend/resume driven by user-space.

It's not "legacy", it's just a different approach to power management.

In principle, it generally is not necessary to support system suspend/resume,
but if your driver is used on a platform that supports it, the driver should
support it too.

Thanks,
Rafael
