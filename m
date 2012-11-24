Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030252Ab2KXJnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 04:43:06 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53307 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030189Ab2KXJnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 04:43:04 -0500
MIME-Version: 1.0
In-Reply-To: <20121124083138.174041677@redhat.com>
References: <20121124082918.671430919@redhat.com>
	<20121124083138.174041677@redhat.com>
Date: Sat, 24 Nov 2012 11:43:03 +0200
X-Google-Sender-Auth: qSOBAHoAHXtfxyDUG8gM5ry8IJg
Message-ID: <CAOJsxLGqb0=L+MgRJ=WGuz+XCec5TM1TXZ95=Ga4TCMXWoubVA@mail.gmail.com>
Subject: Re: [patch 3/8] cpu-hotplug selftests: print failure status instead
 of cause make error
From: Pekka Enberg <penberg@kernel.org>
To: dyoung@redhat.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 10:29 AM,  <dyoung@redhat.com> wrote:
>   bash-4.1$ make -C cpu-hotplug run_tests
>   make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'
>   ./on-off-test.sh
>   make: execvp: ./on-off-test.sh: Permission denied
>   make: *** [run_tests] Error 127
>   make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'
>
> After applying the patch:
>   bash-4.1$ make -C cpu-hotplug run_tests
>   make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'
>   /bin/sh: ./on-off-test.sh: Permission denied
>   cpu-hotplug selftests: [FAIL]
>   make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'
>
> Signed-off-by: Dave Young <dyoung@redhat.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
