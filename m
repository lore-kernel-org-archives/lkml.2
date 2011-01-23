Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab1AWV3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 16:29:05 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42600 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1AWV3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 16:29:03 -0500
MIME-Version: 1.0
In-Reply-To: <201101231845.20505.maciej.rutecki@gmail.com>
References: <4D32FC1C.3010905@simon.arlott.org.uk>
	<201101231845.20505.maciej.rutecki@gmail.com>
Date: Sun, 23 Jan 2011 13:29:02 -0800
Message-ID: <AANLkTimTz=kMmJ=YhyJv28WUrsbN=ygBt9e7dMJ3KGqB@mail.gmail.com>
Subject: Re: 2.6.37 regression: adding main interface to a bridge breaks vlan
 interface RX
From: Jesse Gross <jesse@nicira.com>
To: maciej.rutecki@gmail.com
Cc: Simon Arlott <simon@fire.lp0.eu>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 9:45 AM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> I created a Bugzilla entry at
> https://bugzilla.kernel.org/show_bug.cgi?id=27432
> for your bug report, please add your address to the CC list in there, thanks!

This isn't a bug - the change resolved behavior that varied depending
on what NIC was in use.
