Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108Ab2FAQpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:45:31 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:46508 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759270Ab2FAQp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:45:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIBAG6Zu08Y9geI/2dsb2JhbAANNw6FH6sbhmYBAQEBAyNVARALGAICBRYLAgIJAwIBAgFFBg0BBwEBrxiSe4EmjgqBFAOnO1U
X-IronPort-AV: E=Sophos;i="4.75,637,1330923600"; 
   d="scan'208";a="186017475"
Message-ID: <4FC8F1A7.2060208@teksavvy.com>
Date: Fri, 01 Jun 2012 12:45:27 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: GIT PULL] ext4 updates for 3.5
References: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com>
In-Reply-To: <E1SaTSI-0005UV-4B@tytso-glaptop.cam.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-06-01 11:07 AM, Theodore Ts'o wrote:
> Ext4 updates for 3.5
> 
> The major new feature added in this update is Darrick J. Wong's
> metadata checksum feature, which adds crc32 checksums to ext4's
> metadata fields.  There is also the usual set of cleanups and bug
> fixes.

That sounds vaguely like an on-disk change that may have issues
with systems that regularly switch between older and newer kernel versions.

Could you elaborate on it a bit more, thanks!

