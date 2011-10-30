Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab1J3PpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 11:45:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50092 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934146Ab1J3PpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 11:45:03 -0400
Message-ID: <4EAD70FA.8070405@canonical.com>
Date: Sun, 30 Oct 2011 11:44:58 -0400
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Input: ALPS - Add semi-MT support for v3 protocol
References: <1319663681-11244-1-git-send-email-seth.forshee@canonical.com> <1319663681-11244-7-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1319663681-11244-7-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2011 05:14 PM, Seth Forshee wrote:
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Looks like it does the right thing to me. I believe Seth has tested it
with our uTouch stack, which has some basic support for multitouch
gestures for semi-mt devices.

Acked-by: Chase Douglas <chase.douglas@canonical.com>
