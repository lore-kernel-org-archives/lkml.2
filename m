Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0KBWz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 18:55:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48047 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab0KBWzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 18:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tuaK3TqVIjuObx12Kzn7sFQKwf1kemDBlVN6k08rHM1c1HaeL6KjtPlwb1OT0wRv6j
         fNPwLlDXyb9S6t5Eis5xo+B7PLJhQUHlSdcAPImoPh7DUPTWSHm2NwqgV2bwAnTSfy00
         XduDrppSpvqouRDwaVPfjfoXfAZfnHj2+7WRQ=
MIME-Version: 1.0
Date: Tue, 2 Nov 2010 22:55:23 +0000
Message-ID: <AANLkTik6S4BupU+fZEcJkAexuOhQJYdhpmQa110kzEmd@mail.gmail.com>
Subject: re: 2.6.36 BUG: scheduling while atomic: rc.sysinit/1376/0x00000002
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If I don't use the "discard" mount option for my ext4 / partition, I
don't see these errors.

// Mathias
