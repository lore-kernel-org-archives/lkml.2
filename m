Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab1ANOuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:50:08 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:47434 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1ANOuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:50:03 -0500
Date: Fri, 14 Jan 2011 15:50:01 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 4/7] allow killing tasks in your own or child userns
Message-ID: <20110114145001.GB20945@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	containers@lists.linux-foundation.org,
	kernel list <linux-kernel@vger.kernel.org>,
	LSM <linux-security-module@vger.kernel.org>
References: <20110110211135.GA22446@mail.hallyn.com>
 <20110110211334.GD22564@mail.hallyn.com>
 <20110110215240.GA21351@wavehammer.waldi.eu.org>
 <20110110225151.GA18944@localhost>
 <20110110232335.GA27029@wavehammer.waldi.eu.org>
 <20110111013152.GA23860@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110111013152.GA23860@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 01:31:52AM +0000, Serge E. Hallyn wrote:
> Quoting Bastian Blank (bastian@waldi.eu.org):
> > What is this flag used for anyway? I only see it used in the accounting
> > stuff, and if every user can get it, it is not longer useful.
> hm, I'm not sure...  maybe noone is using it!

This flag is from pre-git.

The only information is:
| #define ASU                0x02    /* ... used super-user privileges */

However with your patches (or at least the goal), everyone is super-user
in derived namespaces.

Bastian

-- 
Where there's no emotion, there's no motive for violence.
		-- Spock, "Dagger of the Mind", stardate 2715.1
