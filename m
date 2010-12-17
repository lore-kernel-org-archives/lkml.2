Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0LQV2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 16:28:03 -0500
Received: from li44-10.members.linode.com ([72.14.181.10]:46587 "EHLO
	plausible.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab0LQV2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 16:28:00 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Dec 2010 16:28:00 EST
Message-ID: <4D0BD443.1070803@plausible.org>
Date: Fri, 17 Dec 2010 13:21:07 -0800
From: Andy Ross <andy@plausible.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] WeTab device ID
References: <4D0AA66F.6080506@plausible.org> <20101217120322.GA3873@polaris>
In-Reply-To: <20101217120322.GA3873@polaris>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 04:03 AM, Henrik Rydberg wrote:
> Thanks for the patch. Does the one below work for you?

Looks like this is against more recent changes than I see in the "hid"
branch of input-mt on kernel.org.  I don't see a
"...EGALAX_MULTITOUCH3" defined there.  Maybe you missed a push?  So
not tested as-is, but certainly looks correct by inspection.

Andy
