Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1KHDz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:55:57 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35207 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab1KHDzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:55:55 -0500
Date: Mon, 7 Nov 2011 19:55:48 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Additional ALPS touchpad protocol support
Message-ID: <20111108035548.GB21927@core.coreip.homeip.net>
References: <1320699160-28492-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320699160-28492-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 02:52:33PM -0600, Seth Forshee wrote:
> Minor updates to previous patches to address review comments and to
> rebase onto ALPS driver changes in 3.2.
> 
> Changes since v1:
> 
>  - Changed to use stack-allocated buffer instead of kmalloced buffer in
>    alps_poll.
>  - Rebased onto alps.c changes merged in 3.2 merge window, changing all
>    debug and error messages to use psmouse_* print statements.
> 
> Seth Forshee (7):
>       Input: ALPS - Move protocol information to Documentation
>       Input: psmouse - Add PSMOUSE_CMD_RESET_WRAP
>       Input: ALPS - Add protocol version field in alps_model_info
>       Input: ALPS - Remove assumptions about packet size
>       Input: ALPS - Add support for protocol versions 3 and 4
>       Input: ALPS - Add semi-MT support for v3 protocol
>       Input: ALPS - Add documentation for protocol versions 3 and 4
> 

Applied all (bit folded 2 into 5). Thanks Seth.

-- 
Dmitry
