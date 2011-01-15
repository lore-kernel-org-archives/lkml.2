Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1AOLac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 06:30:32 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:57904 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1AOLaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 06:30:30 -0500
Date: Sat, 15 Jan 2011 12:30:25 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 4/7] allow killing tasks in your own or child userns
Message-ID: <20110115113025.GB18682@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	containers@lists.linux-foundation.org,
	kernel list <linux-kernel@vger.kernel.org>,
	LSM <linux-security-module@vger.kernel.org>
References: <20110110211135.GA22446@mail.hallyn.com>
 <20110110211334.GD22564@mail.hallyn.com>
 <20110110215240.GA21351@wavehammer.waldi.eu.org>
 <20110110225151.GA18944@localhost>
 <20110110232335.GA27029@wavehammer.waldi.eu.org>
 <20110111013152.GA23860@mail.hallyn.com>
 <20110114145001.GB20945@wavehammer.waldi.eu.org>
 <20110115003114.GA24569@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110115003114.GA24569@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 12:31:14AM +0000, Serge E. Hallyn wrote:
> Quoting Bastian Blank (bastian@waldi.eu.org):
> > On Tue, Jan 11, 2011 at 01:31:52AM +0000, Serge E. Hallyn wrote:
> > > Quoting Bastian Blank (bastian@waldi.eu.org):
> > > > What is this flag used for anyway? I only see it used in the accounting
> > > > stuff, and if every user can get it, it is not longer useful.
> > > hm, I'm not sure...  maybe noone is using it!
> > However with your patches (or at least the goal), everyone is super-user
> > in derived namespaces.
> 
> No, a task just sitting in a derived ns won't necessarily need/use
> super-user privileges...  (and, if we ever get far enough along, it
> won't even necessarily have CAP_SYS_ADMIN/etc targeted to the parent
> userns, bc it won't need those to do the unshares).

The goal, as I understand it, is that everyone can create derived user
namespaces. However the creator have automatically all the capabilities
in the derived namespace. So he can use them to gain this super-user
flag. Even killing a tasks in the derived namespace needs the capability
already.

Bastian

-- 
Those who hate and fight must stop themselves -- otherwise it is not stopped.
		-- Spock, "Day of the Dove", stardate unknown
