Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1JYU4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:56:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20946 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab1JYU4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:56:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=vh2kMlYpWX8IdyT0gwLciMdd5DqqUqqsGv7P3dbIWi+IoC075NKCk+VrvKpb7uTpZ
	QJrCTX+v/qYFlZf9ZzfqQ==
MIME-Version: 1.0
In-Reply-To: <4EA549C3.4080206@ntlworld.com>
References: <4EA549C3.4080206@ntlworld.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Oct 2011 14:55:59 -0600
Message-ID: <CAErSpo4EtfhnhWGpahk-NfMUVEizZSk3igZ+Vy7x=+hY5b0bcw@mail.gmail.com>
Subject: Re: kernel panic
To: nick bray <nick.bray1@ntlworld.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+linux-acpi]

On Mon, Oct 24, 2011 at 5:19 AM, nick bray <nick.bray1@ntlworld.com> wrote:
> Hi,
>  after upgrading to linux kernel 3.xx I get kernel panic on boot unless I
> use ACPI=off in the boot parameters this happens with both Ubuntu 11.10 and
> Fedora 16. The mainboard is an Intel S875WP1-E running a Pentuim 4 3ghz with
> 3gig RAM in single-channel mode. I have performed a Bios upgrade just in
> case tha ACPI tables were corrupt but it makes no difference. Currently
> running 2.6.38-11-generic #50-Ubuntu SMP (Linux Mint) with no issues. I can
> provide a screenshot if you wish but it's looking like it's ACPI related as
> above.

Yes, please provide a screenshot.  A serial console log with "acpi=off
ignore_loglevel" would be even better.

Bjorn
