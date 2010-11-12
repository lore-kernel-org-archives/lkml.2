Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab0KLRYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:24:21 -0500
Received: from shutemov.name ([188.40.19.243]:53901 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab0KLRYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:24:20 -0500
Date: Fri, 12 Nov 2010 19:24:19 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Ben Gamari <bgamari@gmail.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kirill1@shutemov.name
Subject: Re: Mounting blkio cgroup hierarchy
Message-ID: <20101112172419.GA6388@shutemov.name>
References: <87fwv6sbwr.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwv6sbwr.fsf@gmail.com>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 12:13:24PM -0500, Ben Gamari wrote:
> Any ideas?

cat /proc/cgroups ?


-- 
 Kirill A. Shutemov
