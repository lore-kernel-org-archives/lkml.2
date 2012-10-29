Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859Ab2J2UsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:48:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40818 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab2J2UsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:48:15 -0400
Message-ID: <508EEB8C.8@gmail.com>
Date: Mon, 29 Oct 2012 21:48:12 +0100
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko@ursulin.net>
CC: dm-crypt@saout.de, linux-kernel@vger.kernel.org, okozina@redhat.com
Subject: Re: [dm-crypt] cryptsetup not working under 3.6 - regression from
 3.4?
References: <50830D33.5050807@ursulin.net> <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net> <50844D01.9090805@gmail.com> <5084551E.5040304@ursulin.net> <508ED985.5060301@ursulin.net> <508EDD6E.7030908@gmail.com> <508EE395.9010709@ursulin.net>
In-Reply-To: <508EE395.9010709@ursulin.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 09:14 PM, Tvrtko Ursulin wrote:
> Unless RT patchset is the culprit. Hm.. that would be unexpected, but I 
> guess it is worth a shot. I'll let you know what happens without -rt.

Yes, try not patched mainline first.
Focus on the crypto api - if the crypto modules are not loading automatically, as you
said in previous mails, something is misconfigured there - it can be even
related to userspace tools (modprobe, udev, ...) check that you have recent versions.

It works for me here after "make oldconfig" with the .config you sent...

Milan
