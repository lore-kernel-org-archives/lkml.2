Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0FMRIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 13:08:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46052 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0FMRIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 13:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EmScEIMs2z+A9Sk9vwSpT9GFG+UjxD1VPpcyqQuWe8t7fyd9J62ddPg9/5EpghXB/Q
         vL2Wr4z17kYG9ugIcuTGG1OUpWCGdwx8rsESWOIW+5IppwlQAfhwRWbhypXT3iqZRKor
         vpKPzfgwlxH6VXKwjR0Z99hMtvdzGCWZh/vLs=
MIME-Version: 1.0
In-Reply-To: <YPGdyfWGvNK.A.Y9.U8OFMB@chimera>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera>
	<YPGdyfWGvNK.A.Y9.U8OFMB@chimera>
Date: Sun, 13 Jun 2010 20:08:50 +0300
X-Google-Sender-Auth: cqMaSBQOip8FbZo1T3fnz92K-Uw
Message-ID: <AANLkTil5gl_EHnDmiVjxy69uzohEFvOMXxJR8ZbKqOhN@mail.gmail.com>
Subject: Re: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Shi <alex.shi@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 5:48 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15713
> Subject         : hackbench regression due to commit 9dfc6e68bfe6e
> Submitter       : Alex Shi <alex.shi@intel.com>
> Date            : 2010-03-25 8:40 (81 days old)
> First-Bad-Commit: http://git.kernel.org/linus/9dfc6e68bfe6ee452efb1a4e9ca26a9007f2b864
> Message-ID      : <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
> References      : http://marc.info/?l=linux-kernel&m=126950632920682&w=4
> Handled-By      : Christoph Lameter <cl@linux-foundation.org>
>                  Pekka Enberg <penberg@cs.helsinki.fi>

Fixed by:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=73367bd8eef4f4eb311005886aaa916013073265

in 2.6.35-rc1 and the commit is tagged for stable.
