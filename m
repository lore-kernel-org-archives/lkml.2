Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab1KIUuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:50:44 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40915 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932775Ab1KIUum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:50:42 -0500
MIME-Version: 1.0
In-Reply-To: <20111109203546.GI14181@aftab>
References: <1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com>
	<20111109144258.GD30472@aftab>
	<4EBA98A1.90902@ericsson.com>
	<20111109203546.GI14181@aftab>
Date: Wed, 9 Nov 2011 12:50:42 -0800
Message-ID: <CA+8MBbLuhhTZW9vB7GvLCd8Uu7bgfUqkO7wu4=Pt7EWyQx0LrQ@mail.gmail.com>
Subject: Re: [PATCH] amd64_edac: fix size decoding error on K8
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: =?ISO-8859-1?Q?Niklas_S=F6derlund?= <niklas.soderlund@ericsson.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 9, 2011 at 12:35 PM, Borislav Petkov <bp@amd64.org> wrote:
> +               diff = cs_mode / 3 + (unsigned)(cs_mode > 5);
> +
> +               return 32 << (cs_mode - diff);

Code is correct - but looks like an entry for an obfuscated C
competition. Perhaps
it deserves a comment!

-Tony
