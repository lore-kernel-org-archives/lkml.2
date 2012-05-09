Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871Ab2EITdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:33:53 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:55308 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2EITdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:33:49 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Apm4AO/Fqk9V5qg+PGdsb2JhbABEijenXwMBgSIZAQEBAR4ZDSeCDAEBBAE6HCMQCANGFCUKGogcCbt+E4s8gWuDAWMElXyGBo0n
X-IronPort-AV: E=Sophos;i="4.75,559,1330902000"; 
   d="scan'208";a="113452739"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 9 May 2012 21:39:02 +0200
To: Ping Cheng <pinglinux@gmail.com>
Cc: Peter Hutterer <peter.hutterer@who-t.net>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, chatty@enac.fr, chasedouglas@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Input: MT - Include win8 support
Message-ID: <20120509193902.GA12310@polaris.bitmath.org>
References: <1336230499-1450-1-git-send-email-rydberg@euromail.se>
 <CAN+gG=HqGmf77P6=7RMFT_Ez7Ysp4ZVJ6skfAoDcZ7JN1JtYnw@mail.gmail.com>
 <20120506182835.GA12221@polaris.bitmath.org>
 <20120508060221.GA15925@yabbi.bne.redhat.com>
 <20120508184052.GA23748@polaris.bitmath.org>
 <20120508235219.GA4067@yabbi.redhat.com>
 <20120509053502.GA30063@polaris.bitmath.org>
 <CAF8JNhLv3iNgnhzrjEXSFRKUU4hAUKnz1dAadP1FnMxPtu90Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF8JNhLv3iNgnhzrjEXSFRKUU4hAUKnz1dAadP1FnMxPtu90Sg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ping,

> > How about ABS_MT_TOOL_X/Y?
> 
> I am ok if we use any one of the suggested terms. The term is non
> technical per se. Readers will have to look into the spec to
> understand what exactly it means. But, I'd choose ABS_MT_CENTER_X/Y if
> we can only pick one from the suggested ones.
> 
> MT_TOOL_X/Y is unique. But, it introduces TOOL to the term. That makes
> me think about MT_TOOL_FINGER and MT_TOOL_PEN, which are irrelevant to
> this context.

On the contrary, tool as a base makes a lot of sense here. For the
single-pointer case, we have tool types and tool size already. If we
were to add a tool position, we would naturally think of
ABS_TOOL_X/Y. For the MT case, MT_TOOL_* are the tool types, and
ABS_MT_WIDTH_* is the tool size. It was chosen in analogy with
ABS_TOOL_WIDTH, although the TOOL part was dropped in favor of a
shorter name. In retrospect, ABS_MT_POSITION_X should have been named
ABS_MT_TOUCH_X and ABS_MT_WIDTH_MAJOR could have been named
ABS_MT_TOOL_MAJOR. This would more clearly have shown the events being
properties of two objects, tool and touch. With that in mind,
ABS_MT_TOOL_X is a natural choice.

Thanks,
Henrik
