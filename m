Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0FVUjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 16:39:49 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:3650 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab0FVUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 16:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=loTDfu9klQicaetcuu6/7VWZtZhthF5YkFNpmJ48ImsrsFb6RxamLpP+sXS15Km97c
         imSA1ldBaHDQBBKqkYel9gSaYu6YVaQcLtt7zIxpLir6kMvs3edPJiv7KlA1JzhIZd1A
         GqbQTh7SUd3SbsiLIFVH9+nMT8yW948JNJHbQ=
MIME-Version: 1.0
Date: Tue, 22 Jun 2010 22:39:46 +0200
Message-ID: <AANLkTim-cGfemCZFNtmi51nVhH2La1ShOga8EVAhNq-v@mail.gmail.com>
Subject: /proc/gpuinfo
From: "Fred ." <eldmannen@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a /proc/cpuinfo, so why is there no /proc/gpuinfo?

$ cat /proc/gpuinfo
card   	: 0
vendor_id	: Nvidia
gpu family	: GeForce
model	: 8600
model name	: Nvidia(R) GeForce(TM) 8600 GT
gpu MHz	: 475.000
ram size	: 256 MB
gpu cores	: 1
flags		: opengl directx
address size	: 128 bits
