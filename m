Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0LNEbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:31:13 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42576 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757833Ab0LNEbL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:31:11 -0500
MIME-Version: 1.0
In-Reply-To: <8762ux49w7.fsf@deeprootsystems.com>
References: <cover.1290635422.git.bengardiner@nanometrics.ca>
	<cover.1291931041.git.bengardiner@nanometrics.ca>
	<87tyild2ms.fsf@deeprootsystems.com>
	<AANLkTik78Lb0ejUiAvqbkToi=QAKSXXj_6JaBkPYw70Z@mail.gmail.com>
	<AANLkTi=HiJGwtznGRzFDz-4ywsB3rYPW0yF5U_RUruzV@mail.gmail.com>
	<8762ux49w7.fsf@deeprootsystems.com>
Date: Mon, 13 Dec 2010 23:31:09 -0500
Message-ID: <AANLkTin7v4opWvjTt7KLVek=t-Q9_TwhENk+5k-Z3BNW@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] da850-evm: add gpio-{keys,leds} for UI and BB expanders
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 4:53 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Ben Gardiner <bengardiner@nanometrics.ca> writes:
> [...]
> Yes, there will be double commits in master, because of the way I manage
> master using 'git merge -ours'.  But there shouldn't be double commits
> between my "rebuild from braches" merges.  It can be confusing, but if
> you look at the history with a graphical tool like 'gitk', it might shed
> some light on what is going on.

Ok. I'll consider a graphical investigation. Thanks for confirming the
state of master is as-designed.

> I know it's confusing, but the davinci-next branch is the only important
> branch in this tree for upstream purposes.

Understood. Thanks for the clarification.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
