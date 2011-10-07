Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab1JGMf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:35:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab1JGMf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:35:28 -0400
Date: Fri, 7 Oct 2011 08:35:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?= =?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111007123521.GB9452@redhat.com>
References: <1317943022.1095.25.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317943022.1095.25.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 01:17:02AM +0200, Kay Sievers wrote:

[..]
> * fork throttling mechanism as basic cgroup functionality that is
> available in all hierarchies independent of the controllers used:
> This is important to implement race-free killing of all members of a
> cgroup, so that cgroup member processes cannot fork faster then a cgroup
> supervisor process could kill them. This needs to be recursive, so that
> not only a cgroup but all its subgroups are covered as well.

Above should make sense for "freezer" controller too. That will allow us
reliable dynamic migration of tasks in a cgroup by first freezing them,
then change the cgroup and then unfreeze.

Thanks
Vivek
