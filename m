Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1ATUa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:30:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33281 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1ATUa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:30:56 -0500
MIME-Version: 1.0
In-Reply-To: <1295554842.2998.79.camel@work-vm>
References: <1295554842.2998.79.camel@work-vm>
Date: Thu, 20 Jan 2011 12:30:56 -0800
Message-ID: <AANLkTi=Un9x2FXfm+pHGj9eqyvTU1+x84XmMcnFDSuAF@mail.gmail.com>
Subject: Re: sshd issues with 2.6.38-rc1
From: Jesse Gross <jesse@nicira.com>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, apw@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 12:20 PM, john stultz <johnstul@us.ibm.com> wrote:
> Just an FYI: I'm having problems sshing to a machine I just updated to
> 2.6.38-rc1. The machine is running Ubuntu 10.10, and and 2.6.37 with the
> same config doesn't seem to have a problem.
>
> The box is always pingable. But when I ssh in from a client, it just
> hangs before authenticating.

It's likely the checksum offloading issue that was recently fixed in
d402786ea4f8433774a812d6b8635e737425cddd
