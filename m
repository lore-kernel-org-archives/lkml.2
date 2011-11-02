Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab1KBRIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:08:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61922 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab1KBRIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:08:34 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Watts <akwatts@ymail.com>
Subject: Re: [REGRESSION]: hibernate/sleep regression w/ bisection
Date: Wed, 2 Nov 2011 10:08:19 -0700
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        tj@kernel.org
References: <20111101124759.GA1326@zeus> <20111102163109.GA29430@core.coreip.homeip.net> <20111102170058.GA2388@zeus>
In-Reply-To: <20111102170058.GA2388@zeus>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111021008.19531.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 02, 2011 10:01:00 AM Andrew Watts wrote:
> On Wed, Nov 02, 2011 at 09:31:09AM -0700, Dmitry Torokhov wrote:
> > OK, it looks like you do have input, what you do not have is X
> > functioning.
> 
> The extent of my tests on input were to notice that the LED for caps
> lock does not toggle when pressing "caps lock" after a bad resume. I
> have also tried to blindly type "reboot" and such in what should be an
> active xterm.

When in X it is X that is responsible for LED switching. Also input
processing beyond the kernel won't be happening if X is hosed.

-- 
Dmitry
