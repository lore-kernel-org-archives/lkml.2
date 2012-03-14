Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030739Ab2CNX3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:29:30 -0400
Received: from tango.0pointer.de ([85.214.72.216]:34030 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965343Ab2CNX31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:29:27 -0400
Date: Thu, 15 Mar 2012 00:29:25 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] cgroup: deprecate remount option changes and "name="
 mount option
Message-ID: <20120314232925.GA16973@tango.0pointer.de>
References: <20120314215228.GI7349@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314215228.GI7349@google.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14.03.12 14:52, Tejun Heo (tj@kernel.org) wrote:

Heya,

> * "name=" mount option: This has been broken for years before Li fixed
>   it recently.  It has very marginal usefulness (plain bind mount can
>   mostly replace it) and is quite unusual.  Take the chance and mark
>   for deprecation.

Hmm, this is not clear to me. Are you intending to remove the name=
mount option entirely, or just intend to remove that you can change it
in remounts?

systemd uses name=systemd to get its own private cgroup tree, that has
no controller bound, hence we kinda need this option. Or are you
suggesting there was an other way to get a private cgroup tree that
systemd can use for grouping and labelling things?

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
