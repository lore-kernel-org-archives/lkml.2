Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1ANKIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:08:42 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:33064 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427Ab1ANKIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:08:35 -0500
Date: Fri, 14 Jan 2011 12:08:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: balbi@ti.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: error in 2.6.37-git10
Message-ID: <20110114100831.GE2476@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D301CA5.503@example.com>
 <20110114095745.GD2476@legolas.emea.dhcp.ti.com>
 <4D302067.2000203@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D302067.2000203@example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 11:07:35AM +0100, Piotr Hosowicz wrote:
> On 14.01.2011 10:57, Felipe Balbi wrote:
> >On Fri, Jan 14, 2011 at 10:51:33AM +0100, Piotr Hosowicz wrote:
> >>Hello,
> >>
> >>Build failed here:
> >>
> >>   CC [M]  fs/ecryptfs/main.o
> >>fs/ecryptfs/main.c:144: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
> >>‘__attribute__’ before ‘*’ token
> >>fs/ecryptfs/main.c: In function ‘ecryptfs_interpose’:
> >>fs/ecryptfs/main.c:204: error: implicit declaration of function
> >>‘ecryptfs_get_inode’
> >>fs/ecryptfs/main.c:204: warning: initialization makes pointer from
> >>integer without a cast
> >>fs/ecryptfs/main.c:206: error: expected ‘)’ before ‘return’
> >>fs/ecryptfs/main.c:212: error: expected expression before ‘}’ token
> >>fs/ecryptfs/main.c: In function ‘ecryptfs_mount’:
> >>fs/ecryptfs/main.c:569: warning: assignment makes pointer from
> >>integer without a cast
> >
> >Could you check whether this is enough?
> 
> I am building now with this option disabled, maybe I'll have time to
> test again.

I just did. Compiled only that module with that header added. Built
cleanly.

Sent a patch and Cced you too.

-- 
balbi
