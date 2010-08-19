Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab0HSBSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 21:18:55 -0400
Received: from odpn1.odpn.net ([212.40.96.53]:37197 "EHLO odpn1.odpn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab0HSBSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 21:18:53 -0400
From: "Gabor Z. Papp" <gzp@papp.hu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Subject: Re: [0/6] 2.6.27.52 stable review [try 3]
References: <20100818150615.GA4752@kroah.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11)
Date: Thu, 19 Aug 2010 03:18:51 +0200
Message-ID: <x6d3tfh01w@gzp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:

| Here's the 3rd try for the 2.6.27.52 kernel release.  It has 3 more
| patches than the -rc1 release, and two more than -rc2.

What about this?

kbuild: fix make incompatibility
author  Sam Ravnborg <sam@ravnborg.org>
        Sat, 13 Dec 2008 22:00:45 +0000 (23:00 +0100)
committer       Sam Ravnborg <sam@ravnborg.org>
        Sat, 13 Dec 2008 22:00:45 +0000 (23:00 +0100)
commit  31110ebbec8688c6e9597b641101afc94e1c762a
tree    208aaad7e40cbb86bc125760664911da8cd4eebb        tree | snapshot
parent  abf681ce5b6f83f0b8883e0f2c12d197a38543dd        commit | diff
kbuild: fix make incompatibility

"Paul Smith" <psmith@gnu.org> reported that we would fail to build
with a new check that may be enabled in an upcoming version of make.

The error was:

      Makefile:442: *** mixed implicit and normal rules.  Stop.
