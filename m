Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428Ab2FDMmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:42:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33309 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab2FDMmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <4FCCA5A6.8080707@spin.net.au>
References: <4FCCA5A6.8080707@spin.net.au>
Date: Mon, 4 Jun 2012 08:42:08 -0400
Message-ID: <CA+5PVA7v5c2iOhcycw22AgVe_7MKW_eLWkM1fdhju5H0eEUHMQ@mail.gmail.com>
Subject: Re: Fedora 17 custom kernels
From: Josh Boyer <jwboyer@gmail.com>
To: Chris Jones <chrisjones@spin.net.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 8:10 AM, Chris Jones <chrisjones@spin.net.au> wrote:
> Does Fedora 17 boot with custom kernels built on F17? Or is it only having
> issues with custom kernels built on other Linux systems?

You should probably email the Fedora kernel list with this question.
F17 will, in general, boot with custom kernels with the usual degree of
needing to have a proper config.  Starting with the F17 config file
found in /boot is usually a good idea.

josh
