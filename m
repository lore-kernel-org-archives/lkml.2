Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2J2TsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:48:04 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35870 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2J2TsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:48:03 -0400
Message-ID: <508EDD6E.7030908@gmail.com>
Date: Mon, 29 Oct 2012 20:47:58 +0100
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Tvrtko Ursulin <tvrtko@ursulin.net>
CC: Milan Broz <gmazyland@gmail.com>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-crypt] cryptsetup not working under 3.6 - regression from
 3.4?
References: <50830D33.5050807@ursulin.net> <5083C61C.5090807@gmail.com> <5083E4A8.3060501@ursulin.net> <5083E87B.2080908@gmail.com> <5083EC61.8070505@ursulin.net> <50844D01.9090805@gmail.com> <5084551E.5040304@ursulin.net> <508ED985.5060301@ursulin.net>
In-Reply-To: <508ED985.5060301@ursulin.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 08:31 PM, Tvrtko Ursulin wrote:
> Just tried 3.6.4 and it is still broken. Is there anything else I could 
> try to debug this?

See response from response from Ondra on dmcrypt list - your kernel config
is perhaps broken.

Please use fresh checkout, run make oldconfig and try again.
(Many people use 3.6 already and there is no other report.)

Milan
