Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2JHSwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 14:52:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34755 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2JHSwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 14:52:12 -0400
MIME-Version: 1.0
In-Reply-To: <1349430328-18459-1-git-send-email-tklauser@distanz.ch>
References: <1349430328-18459-1-git-send-email-tklauser@distanz.ch>
Date: Mon, 8 Oct 2012 20:52:10 +0200
Message-ID: <CACRpkdY9-U2mW1U7mgXqhnFArysv=tZ7RJjc6LACXSkpvUUZjA@mail.gmail.com>
Subject: Re: [PATCH] gpio/gpio-pl061: Covert to use devm_* functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 11:45 AM, Tobias Klauser <tklauser@distanz.ch> wrote:

> Use the devm_* family of functions during probe to reduce the error
> handling code footprint.
>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Looks good, patch applied.

Yours,
Linus Walleij
