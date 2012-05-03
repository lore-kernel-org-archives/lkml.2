Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2ECIKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:10:16 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49988 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753209Ab2ECIKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:10:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120501132409.GA22894@lizard>
References: <20120501132409.GA22894@lizard>
Date: Thu, 3 May 2012 11:10:12 +0300
X-Google-Sender-Auth: l_FFgGSRRsw4fGkVuhd4JX5sz3U
Message-ID: <CAOJsxLGxKdDnw6RU=1C3VVrwZJ53k_r6gOddYkjxQxjc1-kRXg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmevent: Implement 'low memory' attribute
From: Pekka Enberg <penberg@kernel.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 1, 2012 at 4:24 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Accounting only free pages is very inaccurate for low memory handling,
> so we have to be smarter here.

Can you elaborate on what kind of problems there are with tracking free pages?
