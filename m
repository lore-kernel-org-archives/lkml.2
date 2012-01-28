Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab2A1GbI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 01:31:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35203 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab2A1GbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 01:31:07 -0500
MIME-Version: 1.0
Date: Sat, 28 Jan 2012 01:31:05 -0500
Message-ID: <CAHdPZaMWC6_bGXXJvjbmJDz-JDF7gx8QUTd2e8iW=5+ecTPiSg@mail.gmail.com>
Subject: so many if conditions in _rtl92c_store_pwrIndex_diffrate_offset.
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi wireless folks,

in _rtl92c_store_pwrIndex_diffrate_offset (
drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c), there are lot of
if conditions, checking the register address.
my understanding is that if the register address matches to a
particular rate, we set the txpower level to a particular group. but
it is even possible with the switch or if else if statements,
 please correct me if i am wrong.

Thanks,
Dev.
