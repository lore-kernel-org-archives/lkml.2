Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab2LPBoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 20:44:06 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52797 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2LPBoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 20:44:05 -0500
Date: Sat, 15 Dec 2012 18:21:57 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 21/21] documentation: drop vmtruncate
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <50CC5856.6080704@gmail.com> (from marco.stornelli@gmail.com on
	Sat Dec 15 05:00:38 2012)
X-Mailer: Balsa 2.4.11
Message-Id: <1355617317.24099.10@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2012 05:00:38 AM, Marco Stornelli wrote:
> Removed vmtruncate
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>

Acked-by: Rob Landley <rob@landley.net>

(I can't help thinking there should have been some sort of  
feature-removal-schedule entry for this. Is there any sort of trailing  
record of major stuff that happened and when? The kernelnewbies  
http://kernelnewbies.org/LinuxVersions page is the best I've found, but  
it's a bit clumsy to use as a reference to find which version a change  
happened in. The https://lwn.net/Articles/2.6-kernel-api/ page was  
great but it stalled in 2009. Maybe I just miss kernel-traffic...)

Rob