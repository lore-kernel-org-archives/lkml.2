Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1GUXHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:07:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58056 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1GUXHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:07:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=SoBPI65OcOHB0w/mq+DR+kAihhLZ4Sz8h5tNefTVzj9iDe75w9T48XLNq7q6yI1ia
	ALNs1sM6DXBqh/Rybst8Q==
MIME-Version: 1.0
In-Reply-To: <1311281880-28041-1-git-send-email-mjg@redhat.com>
References: <1311281880-28041-1-git-send-email-mjg@redhat.com>
From: Mike Waychison <mikew@google.com>
Date: Thu, 21 Jul 2011 16:06:55 -0700
Message-ID: <CAGTjWtDRrU3Mnqd+G7oHbYi3shBFP4OhLhYrmGKJnqD8Djhj3w@mail.gmail.com>
Subject: Re: Add efi variables as a pstore backend
To: Matthew Garrett <mjg@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, tony.luck@intel.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 1:57 PM, Matthew Garrett <mjg@redhat.com> wrote:
> The same as the last attempt, but with Tony's comments on patch 4 addressed.
>
>

I just read through these and it looks good to me.

We can deal with the unload side of things when needed.
