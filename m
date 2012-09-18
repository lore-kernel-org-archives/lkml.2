Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2IRQq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:46:58 -0400
Received: from plainfield.sei.cmu.edu ([192.58.107.45]:36839 "EHLO
	plainfield.sei.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2IRQq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:46:56 -0400
From: "Jonathan M. Foote" <jmfoote@cert.org>
To: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, Pedro Alves <palves@redhat.com>
Date: Tue, 18 Sep 2012 12:47:23 -0400
Subject: RE: [PATCH -mm v2] coredump: extend core dump note section to
	contain file names of mapped files
Thread-Topic: [PATCH -mm v2] coredump: extend core dump note section to
	contain file names of mapped files
Thread-Index: Ac2VsyUOiDowEnEvS3ugadlWnKDwIwACVJxg
Message-ID: <A32A045574615B4FAB96C4952BA5768BB9A1B9FC79@EXCHANGE.sei.cmu.edu>
References: <1347980129-1510-1-git-send-email-vda.linux@googlemail.com>
 <20120918153650.GA22122@redhat.com>
In-Reply-To: <20120918153650.GA22122@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change will be beneficial for automated vulnerability triage as well. It will allow tools (like http://www.cert.org/vuls/discovery/triage.html) to gather more information about where an application crashed and the addresses in the backtrace. This information can then be used to help determine the severity of the underlying bug.

Jon

-----Original Message-----
From: Oleg Nesterov [mailto:oleg@redhat.com] 
Sent: Tuesday, September 18, 2012 11:37 AM
To: Denys Vlasenko
Cc: linux-kernel@vger.kernel.org; Andrew Morton; Amerigo Wang; Jonathan M. Foote; Roland McGrath; Pedro Alves
Subject: Re: [PATCH -mm v2] coredump: extend core dump note section to contain file names of mapped files

On 09/18, Denys Vlasenko wrote:
>
> Changes since previous version: rediffed on top of NT_SIGINFO patches.

Assuming this is the only change:

Again, I can't judge whether we need this feature or not, although I tend to trust Denys who actually works with the user-space tools which play with coredumps.

But, from the correctness pov
Reviewed-by: Oleg Nesterov <oleg@redhat.com>

