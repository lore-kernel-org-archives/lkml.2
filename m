Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0LBM43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 07:56:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58320 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab0LBM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 07:56:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:references:in-reply-to:subject:date:message-id:mime-version
         :content-type:content-transfer-encoding:x-mailer:thread-index
         :content-language:x-cr-hashedpuzzle:x-cr-puzzleid;
        b=Bz8hQ2cTF2S8js7z214zGnsfhatX2LCKVmLWRXWEEKGhKFAQPXxdaANypSYg3o/EJZ
         afQN9UDy5dxVcLYlLAtqUzLfHPA2rrD80eVX8eMc/pQiKxdgXpUmHxTglWRmEr+5kAsu
         8wKxj6F02brVH0CPUB6zL8mToly7NOlg+EmbY=
From: "Stanley Gan" <stanley.ganyezu@gmail.com>
To: "'LKML'" <linux-kernel@vger.kernel.org>
References: <20101129180755.GK15818@bombadil.infradead.org> <4CF506A6.4020200@kernel.org> <20101130153839.GM15818@bombadil.infradead.org> <4CF52652.4030802@kernel.org> <20101130163150.GA25668@bombadil.infradead.org> <20101130175317.GB25668@bombadil.infradead.org> <20101130210938.GF25668@bombadil.infradead.org> <4CF62EE0.7040607@kernel.org> <20101201124445.GG25668@bombadil.infradead.org> <4CF6595A.6010104@kernel.org> <20101201155026.GH25668@bombadil.infradead.org>
In-Reply-To: <20101201155026.GH25668@bombadil.infradead.org>
Subject: debug kernel using two laptops without serial port
Date: Thu, 2 Dec 2010 20:56:19 +0800
Message-ID: <4cf79779.2b3bec0a.5180.1bb9@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuRb4gKJ/6TQ7DETEuWwIZA771h7wAAyjDw
Content-Language: zh-cn
x-cr-hashedpuzzle: AIEI BCWA Bq/u CV0B CkRZ CrXW DBg3 DWo8 DthI FEGN Fa5y H9JV JEBY JRfQ MC8k MFGA;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{7C141677-FC6A-4CFB-B413-23348A590BBE};cwB0AGEAbgBsAGUAeQAuAGcAYQBuAHkAZQB6AHUAQABnAG0AYQBpAGwALgBjAG8AbQA=;Wed, 01 Dec 2010 18:45:04 GMT;ZABlAGIAdQBnACAAawBlAHIAbgBlAGwAIAB1AHMAaQBuAGcAIAB0AHcAbwAgAGwAYQBwAHQAbwBwAHMAIAB3AGkAdABoAG8AdQB0ACAAcwBlAHIAaQBhAGwAIABwAG8AcgB0AA==
x-cr-puzzleid: {7C141677-FC6A-4CFB-B413-23348A590BBE}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	I have two dell laptops 1015. For studying Linux kernel, I want to
let one run debugging Linux as client, the other as host. The two laptops
don't have serial port, just have LAN and usb ports. How can I configure
them to get early kernel print message? I ever asked a lot of people, but
don't get answers. Please give me some practical advices, thanks in advance.


stanley

