Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab2KFJCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:02:23 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8748 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KFJCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:02:20 -0500
X-AuditID: cbfee612-b7f8f6d000003efa-bd-5098d21a7e4b
Date: Tue, 06 Nov 2012 09:02:18 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [linux-next PATCH 6/7] PM / devfreq: allow sysfs governor node to
 switch governor
To: Nishanth Menon <nm@ti.com>, linux-pm <linux-pm@vger.kernel.org>
Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121106085814604@myungjoo.ham
Msgkey: 20121106085814604@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121106085814604@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <31153640.425391352192535931.JavaMail.weblogic@epml11>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zXV2pSzMCDJacMrG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZbzZvYymYI1Jxvv0GUwPjFeEuRk4OIQF1iUVLTrKB2BICJhKz
	Pv5lhrDFJC7cWw8U5wKqWcYo8XLHBtYuRg6wojnrJCHi8xkljn/uAmtgEVCRmNB+nAWkhk1A
	T2Lm52SQsLBAnMT0GzOYQGwRAU+JP6c2M4L0Mgv8Y5R4u+UDM8QRShJr9r1iAbF5BQQlTs58
	wgJxhKrExje7GSHiahIHFp6HOk5CYtb0C6wQNq/EjPanUPVyEtO+roGqkZY4P2sDI8wzi78/
	horzSxy7vYMJ4hdeiSf3g2HG7N78BRoOAhJTzxyEatWSuH7xNtQqPok1C9+ywIzZdWo5M0zv
	/S1zwX5kFlCUmNL9kB3C1pL48mMfG7q3eAWcJG4cmco4gVF5FpLULCTts5C0I6tZwMiyilE0
	tSC5oDgpPdVCrzgxt7g0L10vOT93EyMkLQjtYFzWYHGIUYCDUYmHV1BsRoAQa2JZcWXuIUYJ
	DmYlEd4d24BCvCmJlVWpRfnxRaU5qcWHGH2AETiRWUo0OR+YsvJK4g2NDYwNDS0NzUwtTQ1w
	CCuJ83JWTA8QEkhPLEnNTk0tSC2CGcfEwSnVwGgoJfv+b2WDcvq1Iv2wb3+SOu2frTeLCE3j
	sWtn07x/0XZRX6LqVvUsx/2Zu2ptWWpstT4tdvDUuCW1kcf8qLnokkdzpvj/OpDnsWRSOKO2
	dlVG1++gVbMPlAdHP+KUvup6smDPkos9VvVPc8P3P1Otv7lXStKXZTW/3Oz9ztsS1zUXRuow
	KrEUZyQaajEXFScCAPKmJxE4AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/t6bpSl2YEGGzdaGBxedccNgdGj8+b
	5AIYozJsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaKNDIz1jExN9IyMDfRMDGKtDA0MjEyBqhIy
	Mt5s3sZSMEek4nz7DaYGxivCXYycHEIC6hKLlpxk62Lk4JAQMJGYs04SJCwhICZx4d56oDAX
	UMl8Ronjn7uYQRIsAioSE9qPs4DUswnoScz8nAwSFhaIk5h+YwYTiC0i4Cnx59RmRpBeZoF/
	jBJvt3xghtilJLFm3ysWEJtXQFDi5MwnLBDLVCU2vtnNCBFXkziw8DwzRFxCYtb0C6wQNq/E
	jPanUPVyEtO+roGqkZY4P2sDI8zRi78/horzSxy7vYMJ4i9eiSf3g2HG7N78hQ3CFpCYeuYg
	VKuWxPWLt6FW8UmsWfiWBWbMrlPLmWF672+ZC/Yjs4CixJTuh+wQtpbElx/72NC9xSvgJHHj
	yFTGCYxys5CkZiFpn4WkHVnNAkaWVYyiqQXJBcVJ6akWesWJucWleel6yfm5mxjBCeqZ0A7G
	ZQ0WhxgFOBiVeHgFxWYECLEmlhVX5h5ilOBgVhLh3bENKMSbklhZlVqUH19UmpNafIjRBxiB
	E5mlRJPzgckzryTe0NjA2NDQ0tzA1NDIAoewkjgvZ8X0ACGB9MSS1OzU1ILUIphxTBycUg2M
	u3/f/fLEYs7FH3odd8ptT+/12b5F+cFK3tn2j/lfy8xh2LxdWIr3xy1+424WS2b/G2G7GJh/
	zfC+cijc2qdAjiF7r/BOY37DvrMPpFZNvlkW7rX/RZzywyd9CyWvXp698oJn0qdvD+bu9l/z
	8d/GkDJZ/87gye8Lrbu7zmjKVj99dpHrmFyBhBJLcUaioRZzUXEiAHa2xMt9AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA692SE9013887

> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -629,6 +629,44 @@ static ssize_t show_governor(struct device *dev,
>  	return sprintf(buf, "%s\n", to_devfreq(dev)->governor->name);
>  }
>  
> +static ssize_t store_governor(struct device *dev, struct device_attribute *attr,
> +			      const char *buf, size_t count)
> +{
> +	struct devfreq *df = to_devfreq(dev);
> +	int ret = 0;
> +	struct devfreq_governor *governor;
> +
> +	mutex_lock(&devfreq_list_lock);

Please remove the trailing \n from buf here.
When user enters "userspace", buf gets "userspace\n".

With some printks in find_devfreq_governor (printing the buf and governor names):

# echo userspace > /sys/class/devfreq/exynos4210-busfreq.0/governor
[   65.975000] [userspace
[   65.975000] ].[userspace]
[   65.980000] [userspace
[   65.980000] ].[powersave]
[   65.985000] [userspace
[   65.985000] ].[performance]
[   65.990000] [userspace
[   65.990000] ].[simple_ondemand]
[   65.995000] err no = -19
# 





Cheers,
MyungJoo

> +	governor = find_devfreq_governor(buf);
> +	if (IS_ERR(governor)) {
> +		ret = PTR_ERR(governor);
> +		goto out;
> +	}
> +	if (df->governor == governor)
> +		goto out;
> +
> +	if (df->governor) {
> +		ret = df->governor->event_handler(df, DEVFREQ_GOV_STOP, NULL);
> +		if (ret) {
> +			dev_warn(dev, "%s: Governor %s not stopped(%d)\n",
> +				 __func__, df->governor->name, ret);
> +			goto out;
> +		}
> +	}
> +	df->governor = governor;
> +	strncpy(df->governor_name, governor->name, DEVFREQ_NAME_LEN);
> +	ret = df->governor->event_handler(df, DEVFREQ_GOV_START, NULL);
> +	if (ret)
> +		dev_warn(dev, "%s: Governor %s not started(%d)\n",
> +			 __func__, df->governor->name, ret);
> +out:
> +	mutex_unlock(&devfreq_list_lock);
> +
> +	if (!ret)
> +		ret = count;
> +	return ret;
> +}
> +
[]
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
