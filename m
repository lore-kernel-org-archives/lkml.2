Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2JMNxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 09:53:13 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52241 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2JMNxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 09:53:11 -0400
MIME-Version: 1.0
In-Reply-To: <3D1C85A52BB960B79E37AC30@nimrod.local>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
	<20121012133044.GA10115@dhcp22.suse.cz>
	<E6EF14955C67D6CA58918872@nimrod.local>
	<20121012145838.GD22083@dhcp22.suse.cz>
	<3D1C85A52BB960B79E37AC30@nimrod.local>
Date: Sat, 13 Oct 2012 21:53:09 +0800
Message-ID: <CAJd=RBAdpGpSrx9e28MLmPAEhqRsCQGHNuc-sjUQPMTLO9agpQ@mail.gmail.com>
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
From: Hillf Danton <dhillf@gmail.com>
To: Alex Bligh <alex@alex.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Sat, Oct 13, 2012 at 12:29 AM, Alex Bligh <alex@alex.org.uk> wrote:
> Michael,
>
> --On 12 October 2012 16:58:39 +0200 Michal Hocko <mhocko@suse.cz> wrote:
>
>> Once dirty_ratio (resp. dirty_bytes) limit is hit then the process which
>> writes gets throttled. If this is not the case then there is a bug in
>> the throttling code.
>
>
> I believe that is the problem.

Take a look at the "wait for writeback" problem please.

	Linux 3.0+ Disk performance problem - wrong pdflush behaviour
	https://lkml.org/lkml/2012/10/10/412

Hillf
