Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab2CZKEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 06:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733Ab2CZKEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 06:04:23 -0400
Message-ID: <4F703F06.60709@redhat.com>
Date: Mon, 26 Mar 2012 11:03:50 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Nick Bowler <nbowler@elliptictech.com>
CC: Jiri Slaby <jslaby@suse.cz>, Phil Carmody <ext-phil.2.carmody@nokia.com>,
        apw@canonical.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com> <4F6B51C9.6010904@suse.cz> <20120322171702.GA27776@elliptictech.com>
In-Reply-To: <20120322171702.GA27776@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 05:17 PM, Nick Bowler wrote:

> GCC will not normally warn about the above (unless you pass
> -Wold-style-definition) which warns for all function definitions that
> lack a prototype.


/me asks the stupid question:

Why not make the compiler catch this instead then, with -Werror=old-style-definition?

-- 
Pedro Alves
