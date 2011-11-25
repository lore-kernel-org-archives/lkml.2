Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1KYXAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 18:00:15 -0500
Received: from gherkin.frus.com ([192.158.254.49]:39251 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab1KYXAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 18:00:13 -0500
Date: Fri, 25 Nov 2011 17:00:12 -0600
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie
Subject: Re: [BUG] 3.2-rcX radeon KMS system freeze
Message-ID: <20111125230012.GA4014@gherkin.frus.com>
References: <20111125203351.GA3651@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111125203351.GA3651@gherkin.frus.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 02:33:51PM -0600, Bob Tracy wrote:
> Apologies for the less-than-useful bug report.  If there's anything I
> can do to generate/capture more diagnostic info, please don't hesitate
> to let me know.  I'll be able to try a 3.2-rc3 kernel later today.

Update for 3.2-rc3.  Logged-in via the kdm-greeter screen, and just as
soon as the kde session initialization started, I toggled back to a
virtual console to see if any error messages were being written there.
The only suspicious thing I saw was *many* messages in syslog of the
form:

<date> <hostname> kernel: do_entUnaUser: 836779 callbacks suppressed

as "virtuoso-t" started running.  I decided to chance switching to the
X11 session, and it ran for a little while before the system froze.  The
freeze "feels" like an out-of-memory condition, which could explain the
lack of error messages.  Things got really slow just before the system
became completely unresponsive.

--Bob
