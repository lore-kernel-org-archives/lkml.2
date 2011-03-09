Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1CIQTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 11:19:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53443 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab1CIQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 11:19:38 -0500
MIME-Version: 1.0
In-Reply-To: <4D752BAF.4010406@metafoo.de>
References: <1299385050-13674-1-git-send-email-bgat@billgatliff.com>
	<1299385050-13674-2-git-send-email-bgat@billgatliff.com>
	<4D7326B0.6050706@metafoo.de>
	<AANLkTimZXSL9swHgqjsOxoCF8VopM8rkdgFjY-Wyi5Kb@mail.gmail.com>
	<4D752BAF.4010406@metafoo.de>
Date: Wed, 9 Mar 2011 10:19:37 -0600
Message-ID: <AANLkTinZNTY=o7VCgMZv6G1eNW9qk6b60Z4-45ZtV3Sj@mail.gmail.com>
Subject: Re: [PWM v6 1/3] PWM: Implement a generic PWM framework
From: Bill Gatliff <bgat@billgatliff.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 1:02 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>
> There is both. There is 'class_attrs' which are only created once for the class
> and there is 'dev_attrs' which are created on a per device basis.

Got it.  Fixed.  :)


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
