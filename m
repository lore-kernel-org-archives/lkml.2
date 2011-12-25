Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab1LYC0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 21:26:35 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42950 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056Ab1LYC0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 21:26:33 -0500
MIME-Version: 1.0
X-Originating-IP: [76.187.123.11]
In-Reply-To: <201112222255.22288.rjw@sisk.pl>
References: <CABUK1ahQ2yYzaezGc=vDYPrL4ejQgC+9oNtvLeFNJRFf9wAGLw@mail.gmail.com>
	<201112222255.22288.rjw@sisk.pl>
Date: Sat, 24 Dec 2011 20:26:32 -0600
Message-ID: <CABUK1ajfBa6cMmse6Kg8vWOabnaepUqoLAzdnn5X4rAQGNqMpw@mail.gmail.com>
Subject: Re: runtime PM + legacy PM
From: Pavan Savoy <pavan_savoy@sify.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 3:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, December 22, 2011, you wrote:
>> Is there a need for the legacy PM to be enabled when device/drivers
>> run-time PM is supported ?
>
> What do you mean by "legacy PM"?

I meant suspend/resume driven by user-space.

> Rafael
