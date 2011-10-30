Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184Ab1J3Peu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 11:34:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58159 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934146Ab1J3Pes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 11:34:48 -0400
Message-ID: <4EAD6E93.2080002@canonical.com>
Date: Sun, 30 Oct 2011 11:34:43 -0400
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] Input: ALPS - Add protocol version field in alps_model_info
References: <1319663681-11244-1-git-send-email-seth.forshee@canonical.com> <1319663681-11244-4-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1319663681-11244-4-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2011 05:14 PM, Seth Forshee wrote:
> In preparation for adding support for more ALPS protocol versions,
> add a field for the protocol version to the model info instead of
> using a field in the flags. OLDPROTO and !OLDPROTO are now called
> version 1 and version 2, repsectively.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Makes sense, and the old solution obviously was not going to work going
forward.

Acked-by: Chase Douglas <chase.douglas@canonical.com>
